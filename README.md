# Coding Challenge: Playlists

Welcome to the coding challenge.

This challenge will give us an idea about your coding skills. Don't worry if you can't finish all requirements in time. Just tell us how you would proceed.

We're using Rails 4, RSpec 3.5 etc.

In the `csv` folder you find some data files.

## Tasks

- [x] Create a rails application within this repo and commit as usual
- [x] Update the README inside with information on how to work with it if you think that some information might be helpful
- [x] Set up an appropriate data model for the data in the csv files
- [x] Create an import for the users
- [x] Create a simple controller/view to show a list of users
- [x] Create a simple REST API endpoint that returns a list of users as json. The REST API can be treated as internal only so no authentication/authorization is needed here.
- [x] Create an import for the playlists and mp3
- [x] Extend the users view to also show the playlists each user has

## UseCases

- [x] Import users
- [x] List users
- [x] Import MP3
- [x] Import Playlists
- [x] List Playlists of the user

## Description

The application can be accessed at the following address:

https://playlists1.herokuapp.com/

The users API can be accessed at:

https://playlists1.herokuapp.com/api/users

The application is hosted on Heroku and is using the free Postgres database which only accepts 10k rows. It is already in the row's limit so new insertions can cause errors.

### Architecture

The application was developed following the [Clean Architecture](https://8thlight.com/blog/uncle-bob/2012/08/13/the-clean-architecture.html) pattern. Which means it isn't coupled with any framework or database. By doing that, all tests run very fast since they don't depend on any external service. They are just ruby code.

In this application you will find the following layers:

Business Rules (`lib/playlists`):

- Services (UseCases) - Classes that implement the application business logic.
- Entities - Classes used to hold data and perform focused and independent business logic. In this case, they are just simple Data Structures since there is no business logic needed on them.

Framework (`app/`):

- Repositories - Classes responsible for saving and fetching data.
- Models - ActiveRecord models
- Controllers - Rails controllers
- Views - Rails views

All the application business rules were implemented as a library and rails just use it. So there is no reference of any framework inside the business rules and they could easily be extracted into services or external libraries.

The only tests that access the database are the `app/repositories` tests that check if the repositories work and the `app/controllers` which were implemented as integration tests.

### Performance

The application was implemented focusing on code design so the list imports are not optimized. Right now it is inserting one record at a time which may cause request timeouts. Two things could be done to optimize the list imports.

1.  Extract this process to a background job using some tool like `sidekiq`. This would not make the process faster but the request would not be stuck and would not have timeouts anymore.
1.  Import the records in batches. As the file can be very large, creating one batch could be dangerous. But it could be split into batches of 1000 records and mass inserted into the database. Each batch could also be processed in a separate background job to speed up the process even more.
