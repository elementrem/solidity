Solidity
========

Solidity is a contract-oriented, high-level language whose syntax is similar to that of JavaScript
and it is designed to target the Elementrem Virtual Machine.

Solidity is statically typed, supports inheritance, libraries and complex
user-defined types among other features.

As you will see, it is possible to create contracts for voting,
crowdfunding, blind auctions, multi-signature wallets and more.

.. note::
    The best way to try out Solidity right now is using the
    `Browser-Based Compiler <https://elementrem.github.io/browser-solidity/>`_
    (it can take a while to load, please be patient).

Useful links
------------

* `Elementrem <https://elementrem.org>`_

Discontinued:

* `Mix IDE <https://github.com/elementrem/mix/>`_
    Qt based IDE for designing, debugging and testing solidity smart contracts.


Solidity Tools
--------------

* `Dapple <https://github.com/nexusdev/dapple>`_
    Package and deployment manager for Solidity.

* `Solidity REPL <https://github.com/raineorshine/solidity-repl>`_
    Try Solidity instantly with a command-line Solidity console.

* `solgraph <https://github.com/raineorshine/solgraph>`_
    Visualize Solidity control flow and highlight potential security vulnerabilities.

* `evmdis <https://github.com/Arachnid/evmdis>`_
    EVM Disassembler that performs static analysis on the bytecode to provide a higher level of abstraction than raw EVM operations.

Third-Party Solidity Parsers and Grammars
-----------------------------------------

* `solidity-parser <https://github.com/ConsenSys/solidity-parser>`_
    Solidity parser for JavaScript

* `Solidity Grammar for ANTLR 4 <https://github.com/federicobond/solidity-antlr4>`_
    Solidity grammar for the ANTLR 4 parser generator

Language Documentation
----------------------

On the next pages, we will first see a :ref:`simple smart contract <simple-smart-contract>` written
in Solidity followed by the basics about :ref:`blockchains <blockchain-basics>`
and the :ref:`Elementrem Virtual Machine <the-elementrem-virtual-machine>`.

The next section will explain several *features* of Solidity by giving
useful :ref:`example contracts <voting>`
Remember that you can always try out the contracts
`in your browser <https://elementrem.github.io/browser-solidity>`_!

The last and most extensive section will cover all aspects of Solidity in depth.

If you still have questions, you can try searching or asking on the
`Elementrem Stackexchange <https://elementrem.stackexchange.com/>`_
site, or come to our `gitter channel <https://gitter.im/elementrem/solidity/>`_.
Ideas for improving Solidity or this documentation are always welcome!

See also `Russian version (русский перевод) <https://github.com/elementrem/wiki/wiki/%D0%A0%D1%83%D0%BA%D0%BE%D0%B2%D0%BE%D0%B4%D1%81%D1%82%D0%B2%D0%BE-%D0%BF%D0%BE-Solidity>`_.

Contents
========

:ref:`Keyword Index <genindex>`, :ref:`Search Page <search>`

.. toctree::
   :maxdepth: 2

   introduction-to-smart-contracts.rst
   installing-solidity.rst
   solidity-by-example.rst
   solidity-in-depth.rst
   security-considerations.rst
   using-the-compiler.rst
   style-guide.rst
   common-patterns.rst
   contributing.rst
   frequently-asked-questions.rst
