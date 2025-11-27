# frozen_string_literal: true

module Aitch
  class Headers
    extend Forwardable
    include Enumerable

    using Ext

    def_delegators :@store, :each, :empty?, :any?

    def initialize(input = {})
      @store = {}
      input.to_h.each {|key, value| self[key] = value }
    end

    def delete(key)
      @store.delete(normalize_key(key))
    end

    def [](key)
      @store[normalize_key(key)]
    end

    def []=(key, value)
      @store[normalize_key(key)] = value
    end

    def key?(key)
      @store.key?(normalize_key(key))
    end

    def ==(other)
      @store == Headers.new(other).to_h
    end

    def to_h
      @store.dup
    end

    private def normalize_key(key)
      key.to_s.dasherize
    end
  end
end
