module LedgerErrors
  class InvalidTransaction < StandardError; end

  class MinimumEntriesRequired < InvalidTransaction; end
  class UnbalancedTransaction < InvalidTransaction; end
  class DuplicateTransaction < InvalidTransaction; end
  class SameAccountEntries < InvalidTransaction; end
end
