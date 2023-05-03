-- Generated types
type entries = nat | nat | unit
type storage = nat
type context = list operation * storage

sig main : entries * storage -> list operation * storage
let main = fun arguments ->
    -- Retrieve parameters + implicit ones
    let entry = fst arguments in
    let context = [], snd arguments in
    -- Decomposition
    let context =
        fold (entry,
            fun p -> increment (p, context),
            fun p ->
                fold (p,
                    fun p -> decrement (p, context),
                    fun p -> reset (p, context)
                )
        ) in
    (fst context, snd context)

sig increment : nat * context -> context
val increment  = fun arguments ->
    -- Retrieve parameters + implicit ones
    let i = fst arguments in
    let operations = fst (snd arguments) in
    let storage = snd (snd arguments) in
    -- storage += i
    let storage = storage + i in
        operations, storage

sig decrement : nat * context -> context
val decrement = fun arguments ->
    -- Retrieve parameters + implicit ones
    let i = fst arguments in
    let operations = fst (snd arguments) in
    let storage = snd (snd arguments) in
    -- requires { storage >= i -- Cannot decrement more than expected }
    let assert (storage >= i) "Cannot decrement more than expected" in
    -- storage -= i
    let storage = storage - i in
        operations, storage

sig reset : unit * context -> context
val reset = fun arguments ->
    -- Retrieve parameters + implicit ones
    let _ = fst arguments in
    let operations = fst (snd arguments) in
    let storage = snd (snd arguments) in
    -- storage = 0
    let storage = 0 in
        operations, storage
