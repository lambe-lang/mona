-{
    -- Should be checked during the compilation (partial evaluation)
    invariant {
        storage[*] <= Contract.balance
    }
}-

type ledger = map address currency

type entries = nat | nat * (address * currency) | nat * currency
type storage = ledger
type context = list operation * storage

sig main : entries * storage -> operation list * storage
let main = fun arguments ->
    -- Retrieve parameters + implicit ones
    let entry = fst arguments in
    let storage = snd arguments in
    let operations = [] in
    -- Decomposition
    let context =
        fold (entry,
            fun p -> deposit (p, context),
            fun p ->
                fold (p,
                    fun p -> transfer (p, context),
                    fun p -> withdraw (p, context)
                )
        ) in
    (fst context, snd context)

sig deposit : unit * context -> context
val deposit = fun arguments ->
    -- Retrieve parameters + implicit ones
    let _ = fst arguments in
    let operations = fst (snd arguments) in
    let storage = snd (snd arguments) in
    -- storage[Transaction.sender] += Transaction.amount
    let storage_sender = Map.get (storage, Transaction.sender, 0) in
    let storage = Map.set (storage, Transaction.sender, storage_sender + Transaction.amount) in
        operations, storage

sig transfer : (address * currency) * context -> context
val transfer = fun arguments ->
    -- Retrieve parameters + implicit ones
    let destination = fst (fst arguments) in
    let amount = snd (fst arguments) in
    let operations = fst (snd arguments) in
    let storage = snd (snd arguments) in
    -- requires { storage[Transaction.sender] >= amount -- Too much transferred currency }
    let assert (Map.get (storage, Transaction.sender, 0) >= amount) "Too much transferred currency" in
    -- storage[Transaction.sender] -= amount
    let storage_sender = Map.get (storage, Transaction.sender, 0) in
    let storage = Map.set (storage, Transaction.sender, Map.get storage_sender - amount) in
    -- storage[destination] += amount
    let storage_destination = Map.get (storage, Transaction.sender, 0) in
    let storage = Map.set (storage, destination, storage_destination + amount) in
        operations, storage

sig withdraw : currency * context -> context
val withdraw = fun arguments ->
    -- Retrieve parameters + implicit ones
    let amount = fst arguments in
    let operations = fst (snd arguments) in
    let storage = snd (snd arguments) in
    -- requires { storage[Transaction.sender] >= amount -- Too much transferred currency }
    let assert (Map.get (storage, Transaction.sender, 0) >= amount) "Too much transferred currency" in
    -- storage[Transaction.sender] -= amount
    let storage = Map.set (storage, Transaction.sender, Map.get (storage, Transaction.sender, 0) - amount) in
    -- transfer amount to Transaction.sender
    let operations = List.cons (transfer (amount,Transaction.sender), operations) in
        operations, storage
