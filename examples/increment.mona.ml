contract {
    entries increment, decrement, reset
    storage: nat = 0
}

sig increment : nat * nat -> operation list * nat
val increment  = fun arguments ->
    -- Retrieve parameters + implicit ones
    let i = fst arguments in
    let storage = snd arguments in
    let operations = [] in
    -- storage += i
    let storage = storage + i in
        operations, storage
}

sig decrement : nat * nat -> operation list * nat
val decrement = fun arguments ->
    -- Retrieve parameters + implicit ones
    let i = fst arguments in
    let storage = snd arguments in
    let operations = [] in
    -- requires { storage >= i -- Cannot decrement more than expected }
    let assert (storage >= i) "Cannot decrement more than expected" in
    -- storage -= i
    let storage = storage - i in
        operations, storage

sig reset : unit * nat -> operation list * nat
val reset = fun arguments ->
    -- Retrieve parameters + implicit ones
    let _ = fst arguments in
    let storage = snd arguments in
    let operations = [] in
    -- storage = 0
    let storage = 0 in
        operations, storage
