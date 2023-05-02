-{
    -- Should be checked during the compilation (partial evaluation)
    invariant {
        storage[*] <= Contract.balance
    }
}-

type ledger = map nat (map address currency)

type entries = nat | nat * (address * currency) | nat * currency
type storage = ledger

sig main : entries * storage -> operation list * storage
let main = fun arguments ->
    -- Retrieve parameters + implicit ones
    let entry = fst arguments in
    let storage = snd arguments in
    let operations = [] in
    -- Decomposition
    case (entry)
        fun p -> deposit (p, storage)
        fun p -> case p
                    fun p -> transfer (p,storage)
                    fun p -> withdraw (p,storage)

sig deposit : nat * storage -> operation list * storage
val deposit = fun arguments ->
    -- Retrieve parameters + implicit ones
    let token = fst arguments in
    let storage = snd arguments in
    let operations = [] in
    -- storage[token][Transaction.sender] += Transaction.amount
    let storage_token = Map.get (storage,token,Map.empty ()) in
    let storage_token_sender = Map.get (storage_token, Transaction.sender, 0) in
    let storage_token = Map.set (storage_token, Transaction.sender, storage_token_sender + Transaction.amount) in
    let storage = Map.set (storage,token,storage_token) in
        operations, storage

sig transfer : (nat * (address * currency)) * storage -> operation list * storage
val transfer = fun arguments ->
    -- Retrieve parameters + implicit ones
    let token = fst (fst arguments) in
    let destination = fst snd (fst arguments) in
    let amount = snd snd (fst arguments) in
    let storage = snd arguments in
    let operations = [] in
    -- requires { storage[token][Transaction.sender] >= amount -- Too much transferred currency }
    let assert (Map.get (storage, Transaction.sender, 0) >= amount) "Too much transferred currency" in
    -- storage[token][Transaction.sender] -= amount
    let storage_token = Map.get (storage,token,Map.empty ()) in                                             -- -+
    let storage_token_sender = Map.get (storage_token, Transaction.sender, 0)                               --  |
    let storage_token = Map.set (storage_token, Transaction.sender, storage_token_sender - amount) in       --  |
    let storage = Map.set (storage,token,storage_token) in                                                  -- -+
    -- storage[token][destination] += amount
    let storage_token = Map.get (storage,token,Map.empty ()) in                                             -- -+
    let storage_token_destination = Map.get (storage_token, destination, 0) in                              --  |
    let storage_token = Map.set (storage_token, destination, storage_token_destination + amount) in         --  |
    let storage = Map.set (storage,token,storage_token) in                                                  -- -+
        operations, storage

sig withdraw : (nat * currency) * storage -> operation list * storage
val withdraw = fun arguments ->
    let token = fst (fst arguments) in
    let amount = snd (fsf arguments) in
    let storage = snd arguments in
    let operations = [] in
    -- requires { storage[token][Transaction.sender] >= amount -- Too much transferred currency }
    let assert (Map.get (storage, Transaction.sender, 0) >= amount) "Too much transferred currency" in
    -- storage[token][Transaction.sender] -= amount
    let storage_token = Map.get (storage,token,Map.empty ()) in
    let storage_token_sender = Map.get (storage_token, Transaction.sender, 0) in
    let storage_token = Map.set (storage_token, Transaction.sender, storage_token_sender - amount) in
    let storage = Map.set (storage,token,storage_token) in
    -- transfer amount to Transaction.sender
    let operations = List.cons (transfer (amount,Transaction.sender), operations) in
        operations, storage
