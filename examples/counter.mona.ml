type entries = nat | nat | unit
type storage = nat

sig main : entries * storage -> operation list * storage
let main = fun arguments ->
    -- Retrieve parameters + implicit ones
    let entry = fst arguments in
    let storage = snd arguments in
    let operations = [] in
    -- Decomposition
    case (entry)
        fun p -> increment (p, storage)
        fun p -> case p
                    fun p -> decrement (p,storage)
                    fun p -> reset (p,storage)

sig increment : nat * storage -> operation list * storage
val increment  = fun arguments ->
    -- Retrieve parameters + implicit ones
    let i = fst arguments in
    let storage = snd arguments in
    let operations = [] in
    -- storage += i
    let storage = storage + i in
        operations, storage

sig decrement : nat * storage -> operation list * storage
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

sig reset : unit * storage -> operation list * storage
val reset = fun arguments ->
    -- Retrieve parameters + implicit ones
    let _ = fst arguments in
    let storage = snd arguments in
    let operations = [] in
    -- storage = 0
    let storage = 0 in
        operations, storage
