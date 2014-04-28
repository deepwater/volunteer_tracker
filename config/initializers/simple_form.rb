# Use this setup block to configure all options available in SimpleForm.
SimpleForm.setup do |config|
  # Wrappers are used by the form builder to generate a
  # complete input. You can remove any component from the
  # wrapper, change the order or even add your own to the
  # stack. The options given below are used to wrap the
  # whole input.

  inputs = %w[
    CollectionSelectInput
    DateTimeInput
    FileInput
    GroupedCollectionSelectInput
    NumericInput
    PasswordInput
    RangeInput
    StringInput
    TextInput
  ]
   
  inputs.each do |input_type|
    superclass = "SimpleForm::Inputs::#{input_type}".constantize
   
    new_class = Class.new(superclass) do
      def input_html_classes
        super.push('form-control')
      end
    end
   
    Object.const_set(input_type, new_class)
  end

  config.wrappers :bootstrap, tag: 'div', class: 'form-group', error_class: 'error' do |b|
    b.use :html5
    b.use :placeholder
    b.use :label
    b.use :input, class: 'form-control'
    b.use :error, wrap_with: { tag: 'span', class: 'help-inline' }
    b.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
  end

  config.wrappers :bootstrap3, tag: 'div', class: 'form-group', error_class: 'has-error' do |b|
    b.use :html5
    b.use :min_max
    b.use :maxlength
    b.use :placeholder
    
    b.optional :pattern
    b.optional :readonly
    
    b.use :label, class: 'col-sm-3 control-label'
    b.use :input, class: 'col-sm-9'
    b.use :hint,  wrap_with: { tag: 'span', class: 'help-block col-sm-9 col-sm-offset-3' }
    b.use :error, wrap_with: { tag: 'span', class: 'help-block has-error' }
  end
 
  config.wrappers :prepend, tag: 'div', class: 'form-group', error_class: 'has-error' do |b|
    b.use :html5
    b.use :placeholder
    b.wrapper tag: 'div', class: 'controls' do |input|
      input.wrapper tag: 'div', class: 'input-group' do |prepend|
        prepend.use :label , class: 'input-group-addon'
        prepend.use :input
      end
      input.use :hint,  wrap_with: { tag: 'span', class: 'help-block' }
      input.use :error, wrap_with: { tag: 'span', class: 'help-block has-error' }
    end
  end
 
  config.wrappers :append, tag: 'div', class: 'form-group', error_class: 'has-error' do |b|
    b.use :html5
    b.use :placeholder
    b.wrapper tag: 'div', class: 'controls' do |input|
      input.wrapper tag: 'div', class: 'input-group' do |prepend|
        prepend.use :input
        prepend.use :label , class: 'input-group-addon'
      end
      input.use :hint,  wrap_with: { tag: 'span', class: 'help-block' }
      input.use :error, wrap_with: { tag: 'span', class: 'help-block has-error' }
    end
  end
 
  config.wrappers :checkbox, tag: :div, class: "form-group", error_class: "has-error" do |b|
 
    # Form extensions
    b.use :html5
 
    # Form components
    b.wrapper tag: 'div', class: 'col-sm-9 col-sm-offset-3' do |b|
      b.wrapper tag: 'div', class: 'checkbox' do |b|
        b.wrapper tag: :label do |ba|
          ba.use :input
          ba.use :label_text
        end
      end
    end
 
    b.use :hint,  wrap_with: { tag: :p, class: "help-block" }
    b.use :error, wrap_with: { tag: :span, class: "help-block text-danger" }
  end

  # Wrappers for forms and inputs using the Twitter Bootstrap toolkit.
  # Check the Bootstrap docs (http://twitter.github.com/bootstrap)
  # to learn about the different styles for forms and inputs,
  # buttons and other elements.
  config.default_wrapper = :bootstrap3

end
