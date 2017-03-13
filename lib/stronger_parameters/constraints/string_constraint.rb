require 'stronger_parameters/constraints'

module StrongerParameters
  class StringConstraint < Constraint
    attr_reader :maximum_length, :minimum_length

    def initialize(options = {})
      @maximum_length = options[:maximum_length] || options[:max_length]
      @minimum_length = options[:minimum_length] || options[:min_length]
      @reject_null_bytes = options.fetch(:reject_null_bytes, true)
    end

    def value(v)
      if v.is_a?(String)
        if maximum_length && v.bytesize > maximum_length
          return InvalidValue.new(v, "can not be longer than #{maximum_length} bytes")
        elsif minimum_length && v.bytesize < minimum_length
          return InvalidValue.new(v, "can not be shorter than #{minimum_length} bytes")
        elsif !v.valid_encoding?
          return InvalidValue.new(v, 'must have valid encoding')
        elsif reject_null_bytes? && v.include?("\u0000")
          return InvalidValue.new(v, 'can not contain any null bytes')
        end

        return v
      end

      InvalidValue.new(v, 'must be a string')
    end

    def ==(other)
      super && maximum_length == other.maximum_length
    end

    private

    def reject_null_bytes?
      @reject_null_bytes
    end
  end
end
