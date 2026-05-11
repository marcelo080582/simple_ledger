module LedgerErrors
  class UnbalancedTransaction < StandardError; end
  class MinimumEntriesRequired < StandardError; end
end
