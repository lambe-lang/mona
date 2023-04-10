contract {
    entries deposit, transfer, withdraw
    storage: ledger = [*:0] -- 0 should be the neutral currency value
}

type ledger = map address currency

-{
    -- Should be checked during the compilation (partial evaluation)
    invariant {
        storage[*] <= Contract.balance
    }
}-

sig deposit : (unit * ledger) -> operation list * ledger
val deposit = fun arguments ->
    let _ = fst arguments in
    let storage = snd arguments in
    let operations = [] in
    let storage = Map.set (storage, Transaction.sender, Map.get (storage, Transaction.sender, 0) + Transaction.amount) in
        operations, storage
}

sig transfer : (address * currency) * ledger -> operation list * ledger
val transfer = fun arguments ->
    let destination = fst (fst arguments) in
    let amount = snd (fst arguments) in
    let storage = snd arguments in
    let assert Map.get (storage, Transaction.sender, 0) >= amount "Too much transferred currency" in
    let operations = [] in
    let storage = Map.set (storage, Transaction.sender, Map.get (storage, Transaction.sender, 0) - amount) in
    let storage = Map.set (storage, destination, Map.get (storage, destination, 0) + amount) in
        operations, storage
}

sig withdraw : currency * ledger -> operation list * ledger
val withdraw = fun arguments ->
    let amount = fst arguments in
    let storage = snd arguments in
    let assert Map.get (storage, Transaction.sender, 0) >= amount "Too much transferred currency" in
    let operations = [] in
    let storage = Map.set (storage, Transaction.sender, Map.get (storage, Transaction.sender, 0) - amount) in
    let operations = List.cons (transfer (amount,Transaction.sender)) operations in
        operations, storage
}
