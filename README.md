# Mona programming language

Mona is a Smart-Contract centric language.  

# Examples

```js
contract {
    entries: deposit, transfer, withdraw
    storage: ledger = [*:0] -- 0 should be the neutral currency value
}

type ledger = [address:currency]

invariant {
    -- Impossible to have the equality since origination can accept some currency for the balance
    storage[*] <= Contract.balance
}

fun deposit() {
    storage[Transaction.sender] += Transaction.amount
}

fun transfer(destination: address, amount: currency) {
    requires {
        storage[Transaction.sender] >= amount -- Too much transferred currency
    }

    storage[Transaction.sender] -= amount
    storage[destination] += amount
}

fun withdraw(amount : currency) {
    requires {
        storage[Transaction.sender] >= amount -- Too much transferred currency
    }

    storage[Transaction.sender] -= amount
    transfer amount to Transaction.sender
}


## LICENSE

MIT License

Copyright (c) 2023 Mona Language

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
