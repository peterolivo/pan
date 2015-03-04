context = ChefDK::Generator.context
cookbook_dir = File.join(context.cookbook_root, context.cookbook_name)
attribute_context = context.cookbook_name.gsub(/-/, '_')

# Create cookbook directories
cookbook_directories = [
  'attributes',
  'recipes',
  'templates/default',
  'files/default',
  'test/integration/default/serverspec/localhost'
]
cookbook_directories.each do |dir|
  directory File.join(cookbook_dir, dir) do
    recursive true
  end
end

# Create basic files
files_basic = [
  'chefignore',
  'Berksfile',
  'Gemfile',
  'LICENSE',
  'Thorfile'
]
files_basic.each do |file|
  cookbook_file File.join(cookbook_dir, file) do
    action :create_if_missing
  end
end

# Create basic files from template
files_template = [
  'metadata.rb',
  'README.md',
  'CHANGELOG.md',
  '.kitchen.yml',
]
files_template.each do |file|
  template File.join(cookbook_dir, file) do
    helpers(ChefDK::Generator::TemplateHelper)
    action :create_if_missing
  end
end

# Create more complex files from templates
template "#{cookbook_dir}/attributes/default.rb" do
  source 'default_attributes.rb.erb'
  helpers(ChefDK::Generator::TemplateHelper)
  action :create_if_missing
  variables(
    attribute_context: attribute_context)
end
template "#{cookbook_dir}/recipes/default.rb" do
  source 'default_recipe.rb.erb'
  helpers(ChefDK::Generator::TemplateHelper)
  action :create_if_missing
end
template "#{cookbook_dir}/test/integration/default/serverspec/spec_helper.rb" do
  source 'spec_helper.rb.erb'
  helpers(ChefDK::Generator::TemplateHelper)
  action :create_if_missing
end