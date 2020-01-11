module Recommendations
  Decision = Struct.new(:date, :budget, :template_path, :template_data) do
    # Renders +template_data+ in the ERB template specified in +template_path+
    #
    # @return [String]
    def rendered_template
      data = { date: date, budget: budget }.merge(**template_data)
      ERB.new(File.read(template_path), nil, '-').result_with_hash(data)
    end
  end
end