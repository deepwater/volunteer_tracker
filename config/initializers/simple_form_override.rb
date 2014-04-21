SimpleForm::FormBuilder.instance_exec do |it|
  alias_method :input_original, :input
  define_method(:input) do |attribute_name, options={}, &block|
    if options[:as] == :boolean
      options[:wrapper] = :checkbox
    end
    input_original attribute_name, options, &block
  end
end