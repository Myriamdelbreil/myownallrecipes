all_data = YAML.load_file(Rails.root.join('config', 'ingredients.yml'))
SHARED_INGREDIENTS = all_data['ingredients'].freeze
