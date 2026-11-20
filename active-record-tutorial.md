# Active Record tutorial for Rails 8.1

**Prerequisite** — Finish the [Rails Hello World course](rails-neovim-hello-world-course.md). Allow about 45 minutes. You'll create a `Note` model, learn how Ruby objects map to SQLite rows, and display saved notes in your browser.

## 1. Connect a Ruby model to a database table

In your Hello World app, the controller set `@message` to a string written in the code. A notes app needs to keep data entered while the app is running and retrieve it later. Active Record is the part of Rails that maps Ruby objects to relational database records. SQLite stores the data, while Active Record translates operations such as `Note.find(id)` into database queries.

| In Ruby | In SQLite |
| --- | --- |
| `Note` class | `notes` table |
| A saved `Note` instance | One row in `notes` |
| `note.title` | The value of the row's `title` column |
| `note.id` | The row's primary key, which identifies it |

The singular class name and plural table name are Rails conventions. You'll use both the model and its database table in the next step.

## 2. Generate the model and run the migration

From the workspace root, enter the Hello World app. Run the shell blocks from this app directory. If your terminal only finds macOS's Ruby, prefix the Rails commands with `mise exec --`.

```bash
cd rails/hello_rails
bin/rails --version
bin/rails generate model Note title:string body:text
```

Run the generator once. It creates `app/models/note.rb` and a timestamped file ending in `_create_notes.rb` under `db/migrate/`, among other files. The model defines Ruby behavior. The migration describes a change to the database structure.

Before running the migration, open the generated migration in Neovim. Make sure the table definition has these lines. Keep the generated class and method around them.

```ruby
create_table :notes do |t|
  t.string :title, null: false
  t.text :body

  t.timestamps
end
```

Rails adds the primary key `id` by default. `t.timestamps` adds `created_at` and `updated_at`, which Active Record maintains on ordinary saves. `null: false` tells the database to reject SQL `NULL` for the title. An empty string is still a value, so you'll add a model validation for blank titles later.

```bash
bin/rails db:migrate
bin/rails db:migrate:status
```

**Check:** The `Create notes` migration should be marked `up`. Open `db/schema.rb` and look for the `notes` table. The migration records how to change the database, and the schema file shows its resulting structure. For a later schema change, create a new migration once the original has been shared or applied elsewhere.

## 3. Create, read, update, and delete records

Open the Rails console with `bin/rails console`. Run the Ruby snippets in this section in the same console session so the variables stay available.

**Create.** `new` builds an object in memory. `save!` writes it to SQLite. `create!` combines the two operations. The bang versions raise an exception when a validation prevents saving.

```ruby
note = Note.new(title: "Learn Active Record", body: "Start with persistence.")
note.persisted? # => false
note.save!      # => true
note.persisted? # => true

practice = Note.create!(title: "Practice note", body: "A disposable example.")
```

**Read.** Use the ID Rails assigned instead of assuming the first row has ID 1. `find` looks up a primary key and raises `ActiveRecord::RecordNotFound` if it is missing. `find_by` looks up one match by attributes and returns `nil` if there is none.

```ruby
Note.find(note.id).title              # => "Learn Active Record"
Note.find_by(id: note.id).title       # => "Learn Active Record"
```

**Update.** Assignment changes the Ruby object. `reload` fetches the row again and discards unsaved changes. Use `update!` to assign and save in one call.

```ruby
note.body = "This change is only in memory."
note.reload.body # => "Start with persistence."
note.update!(body: "I can save and reload a record.")
note.reload.body # => "I can save and reload a record."
```

**Delete.** Destroy only the disposable record you made above. Keep the first note for the browser exercise.

```ruby
practice.destroy!
Note.exists?(practice.id) # => false
```

**Check:** Write down the value of `note.id`, type `exit`, and reopen the console. Use `Note.find` with that number. The Ruby variable disappeared when you exited, but the row persisted.

## 4. Build a query and inspect its SQL

In the console, build a query for the first note's title and read the selected rows.

```ruby
results = Note.where(title: "Learn Active Record").order(id: :desc).limit(5)
puts results.to_sql
results.loaded? == true # => false
results.to_a
results.loaded?         # => true
```

`where`, `order`, and `limit` return an `ActiveRecord::Relation`, a query you can build in steps. `to_sql` shows the SQL for the query without loading its rows. `to_a` executes the query and gives you an array of `Note` objects. In the SQL, look for `WHERE`, `ORDER BY`, and `LIMIT`. Assignments in the Rails console may automatically inspect the relation and run a preview query. The `loaded?` checks above refer to the original relation.

When filtering on a value supplied by a user, prefer the hash form shown above. For SQL expressions, pass the value separately, as in `Note.where("id > ?", minimum_id)`. This gives Active Record the query and the value separately so it can handle quoting correctly.

## 5. Validate a title before saving

Exit the console. Open `app/models/note.rb` and make it look like this.

```ruby
class Note < ApplicationRecord
  validates :title, presence: true
end
```

Start a fresh Rails console to load the edited model. Try a note whose title contains only spaces.

```ruby
invalid_note = Note.new(title: "   ", body: "A title is required.")
invalid_note.save          # => false
invalid_note.errors[:title] # => ["can't be blank"]
invalid_note.persisted?    # => false
```

The model validation rejects blank titles and gives the application a message it can show to a user. The database constraint from step 2 separately rejects `NULL` even when a write bypasses model validations. The two checks protect different conditions.

## 6. Display saved notes in the browser

Exit the console. Generate a controller without asking the generator to create any routes.

```bash
bin/rails generate controller Notes --skip-routes
```

Set `app/controllers/notes_controller.rb` to the following.

```ruby
class NotesController < ApplicationController
  def index
    @notes = Note.order(id: :desc)
  end
end
```

In `config/routes.rb`, add the following line inside the existing `Rails.application.routes.draw do` block. Keep the Hello World root route.

```ruby
resources :notes, only: :index
```

Create `app/views/notes/index.html.erb`.

```erb
<h1>Notes</h1>

<ul>
  <% @notes.each do |note| %>
    <li>
      <h2><%= note.title %></h2>
      <p><%= note.body %></p>
    </li>
  <% end %>
</ul>
```

Run `bin/rails routes -g notes` to confirm that `GET /notes` maps to `notes#index`. Start `bin/rails server` and visit [localhost:3000/notes](http://localhost:3000/notes). You should see **Learn Active Record** with the updated body. Add another valid note in a second terminal's Rails console and refresh the page. The original Hello World page is still at `/`.

## Practice on your own

1. Create three notes. Query the newest two using only `order` and `limit`, then inspect the SQL.
2. Try changing a saved note's title to a blank string with `update`. Check its return value and errors, then use `reload` to see what remained in the database.
3. As a next step, design a `Comment` model. One note can have many comments, and each comment belongs to one note. Decide which table should store `note_id` before reading the [association guide](https://guides.rubyonrails.org/association_basics.html).

If Rails reports a pending migration or a missing `notes` table, run `bin/rails db:migrate:status` in the app directory and confirm that the server and console use the same Rails environment. If `Note` is undefined, check that the file is `app/models/note.rb`, that the class is named `Note`, and that you restarted the console after editing it.

For more examples, see the official [Active Record Basics](https://guides.rubyonrails.org/active_record_basics.html), [Migrations](https://guides.rubyonrails.org/active_record_migrations.html), [Query Interface](https://guides.rubyonrails.org/active_record_querying.html), and [Validations](https://guides.rubyonrails.org/active_record_validations.html) guides.
