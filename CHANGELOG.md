# CHANGELOG

## Version 5.0.0

### Breaking changes

#### Removed support for deprecated variables

- `Pagy::VARS[:anchor]` is now `Pagy::VARS[:fragment]`

#### Removed support for deprecated arguments order

- The argument order `pagy_url_for(page, pagy)` is now inverted: `pagy_url_for(pagy, page)`

#### Removed support for deprecated positional arguments

The following optional positional arguments are passed with keywords arguments in all the pagy helpers:

- The `id` html attribute string with the `pagy_id` keyword 
- The `url/absolute` flag with the `absolute` keyword 
- The `item_name` string with the `item_name` keyword
- The `extra/link_extra` string with the `link_extra` keyword
- The `text` string with the `text` keyword
