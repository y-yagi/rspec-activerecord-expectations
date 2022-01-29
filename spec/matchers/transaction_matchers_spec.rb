require 'spec_helper'

RSpec.xdescribe RSpec::ActiveRecord::Expectations::Matchers::TransactionMatcher do
  let(:example) { Proc.new {} }

  it "has positive expectation output" do
    matcher = described_class.new(:transaction_queries)

    matcher.matches?(example)

    expect(matcher.failure_message).to eq("expected block to execute a transaction, but it didn't do so")
  end

  it "has negative expectation output" do
    matcher = described_class.new(:transaction_queries)
    allow(matcher.collector).to receive(:queries_of_type).and_return(1)

    matcher.matches?(example)

    expect(matcher.failure_message_when_negated).to eq("expected block not to execute a transaction, but it executed one")
  end

  it "has negative expectation output when multiple transactions were executed" do
    matcher = described_class.new(:transaction_queries)
    allow(matcher.collector).to receive(:queries_of_type).and_return(2)

    matcher.matches?(example)

    expect(matcher.failure_message_when_negated).to eq("expected block not to execute a transaction, but it executed 2 transactions")
  end

  context "rollbacks" do
    it "has positive expectation output" do
      matcher = described_class.new(:rollback_queries)

      matcher.matches?(example)

      expect(matcher.failure_message).to eq("expected block to roll back a transaction, but it didn't do so")
    end

    it "has negative expectation output" do
      matcher = described_class.new(:rollback_queries)
      allow(matcher.collector).to receive(:queries_of_type).and_return(1)

      matcher.matches?(example)

      expect(matcher.failure_message_when_negated).to eq("expected block not to roll back a transaction, but it rolled one back")
    end

    it "has negative expectation output when multiple transactions were rolled back" do
      matcher = described_class.new(:rollback_queries)
      allow(matcher.collector).to receive(:queries_of_type).and_return(3)

      matcher.matches?(example)

      expect(matcher.failure_message_when_negated).to eq("expected block not to roll back a transaction, but it rolled back 3 transactions")
    end
  end

  context "commits" do
    it "has positive expectation output" do
      matcher = described_class.new(:commit_queries)

      matcher.matches?(example)

      expect(matcher.failure_message).to eq("expected block to commit a transaction, but it didn't do so")
    end

    it "has negative expectation output" do
      matcher = described_class.new(:commit_queries)
      allow(matcher.collector).to receive(:queries_of_type).and_return(1)

      matcher.matches?(example)

      expect(matcher.failure_message_when_negated).to eq("expected block not to commit a transaction, but it committed once")
    end

    it "has negative expectation output when multiple transactions were rolled back" do
      matcher = described_class.new(:commit_queries)
      allow(matcher.collector).to receive(:queries_of_type).and_return(3)

      matcher.matches?(example)

      expect(matcher.failure_message_when_negated).to eq("expected block not to commit a transaction, but it committed 3 transactions")
    end
  end

  context "quantified output" do
    it "has positive quantified output" do
      matcher = described_class.new(:commit_queries)
      matcher.twice
      allow(matcher.collector).to receive(:queries_of_type).and_return(3)

      expect(matcher.failure_message).to eq("expected block to commit a transaction twice, but it committed 3 times")
    end

    it "has negative quantified output" do
      matcher = described_class.new(:commit_queries)
      matcher.exactly(3).times
      allow(matcher.collector).to receive(:queries_of_type).and_return(3)

      expect(matcher.failure_message_when_negated).to eq("expected block not to commit 3 times, but it did do so")
    end

    it "has some tortured phrasing" do
      matcher = described_class.new(:commit_queries)
      matcher.at_least(3).times
      allow(matcher.collector).to receive(:queries_of_type).and_return(4)

      expect(matcher.failure_message_when_negated).to eq("expected block not to commit 3 or more times, but it committed 4 times")
    end
  end
end
