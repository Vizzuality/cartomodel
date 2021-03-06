# Cartomodel

[![Build Status](https://travis-ci.org/Vizzuality/cartomodel.svg?branch=master)](https://travis-ci.org/Vizzuality/cartomodel)

ActiveRecord integration for Cartowrap gem

Currently happy case based, not very configurable

PRs are welcome ;)

# Usage

This gem integrates [Cartowrap](https://github.com/tiagojsag/cartowrap) with ActiveRecord.
Before using, follow the configuration instructions of Cartowrap.

You must manually configure your CartoDB account, create the table and ensure that the structure matches

Once that is done, configure your local model like so:

```
class YourModelClass < ApplicationRecord
  include Cartomodel::Model::Synchronizable

  def cartodb_table
    'indicator_config'
  end
end
```

Make sure that your model has the two following columns:

```
class AddCartomodelColumnsYourModel < ActiveRecord::Migration
  def change
    add_column :indicator_configs, :cartodb_id, :integer
    add_column :indicator_configs, :sync_state, :integer
  end
end
```

# Sync

If CartoDB, for some reason, fails to save your data, you can retry later using a rake task:

```
rake cartomodel:sync
```

To use this task, you need to add the following to your Rakefile:

```
spec = Gem::Specification.find_by_name 'cartomodel'
load "#{spec.gem_dir}/tasks/sync.rake"
```

Currently the task prints no output on progress or success

# Custom attributes

If you want to have special attributes synced to Carto, use the following:

```
class YourModelClass < ApplicationRecord
  include Cartomodel::Model::Synchronizable

  def custom_cartodb_attributes(attributes)
    attributes['custom_attribute'] = 'custom_value'
    attributes
  end
end

```
