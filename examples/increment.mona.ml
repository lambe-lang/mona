contract {
    entries increment, decrement, reset
    storage: nat = 0
}

sig increment : nat * nat -> operation list * nat
val increment  = fun arguments ->
    let i = fst arguments in
    let storage = snd arguments in
    let operations = [] in
    let storage = storage + i in
        operations, storage
}

let decrement : nat * nat -> operation list * nat
val decrement = fun arguments ->
    let i = fst arguments in
    let storage = snd arguments in
    let assert storage >= i "Cannot decrement more than expected" in
    let operations = [] in
    let storage = storage - i in
        operations, storage

sig reset : unit * nat -> operation list * nat
val reset = fun arguments ->
    let _ = fst arguments in
    let storage = snd arguments in
    let operations = [] in
    let storage = 0 in
        operations, storage
