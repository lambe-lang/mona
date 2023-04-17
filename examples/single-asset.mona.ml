contract {
    entries deposit, transfer, withdraw
    storage: ledger
}

type ledger = map address currency

-{
    -- Should be checked during the compilation (partial evaluation)
    invariant {
        storage[*] <= Contract.balance
    }
}-

sig deposit : unit * ledger -> operation list * ledger
val deposit = fun arguments ->
    -- Retrieve parameters + implicit ones
    let _ = fst arguments in
    let storage = snd arguments in
    let operations = [] in
    -- storage[Transaction.sender] += Transaction.amount
    let storage_sender = Map.get (storage, Transaction.sender, 0) in
    let storage = Map.set (storage, Transaction.sender, storage_sender + Transaction.amount) in
        operations, storage
}

sig transfer : (address * currency) * ledger -> operation list * ledger
val transfer = fun arguments ->
    -- Retrieve parameters + implicit ones
    let destination = fst (fst arguments) in
    let amount = snd (fst arguments) in
    let storage = snd arguments in
    let operations = [] in
    -- requires { storage[Transaction.sender] >= amount -- Too much transferred currency }
    let assert (Map.get (storage, Transaction.sender, 0) >= amount) "Too much transferred currency" in
    -- storage[Transaction.sender] -= amount
    let storage_sender = Map.get (storage, Transaction.sender, 0) in
    let storage = Map.set (storage, Transaction.sender, Map.get storage_sender - amount) in
    -- storage[destination] += amount
    let storage_destination = Map.get (storage, Transaction.sender, 0) in
    let storage = Map.set (storage, destination, storage_destination + amount) in
        operations, storage
}

sig withdraw : currency * ledger -> operation list * ledger
val withdraw = fun arguments ->
    -- Retrieve parameters + implicit ones
    let amount = fst arguments in
    let storage = snd arguments in
    let operations = [] in
    -- requires { storage[Transaction.sender] >= amount -- Too much transferred currency }
    let assert (Map.get (storage, Transaction.sender, 0) >= amount) "Too much transferred currency" in
    -- storage[Transaction.sender] -= amount
    let storage = Map.set (storage, Transaction.sender, Map.get (storage, Transaction.sender, 0) - amount) in
    -- transfer amount to Transaction.sender
    let operations = List.cons (transfer (amount,Transaction.sender), operations) in
        operations, storage
}
