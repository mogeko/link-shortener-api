# ShortenApi

[![.github/workflows/test.yml](https://github.com/mogeko/link-shortener-api/actions/workflows/test.yml/badge.svg)](https://github.com/mogeko/link-shortener-api/actions/workflows/test.yml)
[![codecov](https://codecov.io/gh/mogeko/link-shortener-api/branch/master/graph/badge.svg?token=4lvEOie9Hj)](https://codecov.io/gh/mogeko/link-shortener-api)

**This is a project for learning Elixir.**

I wrote a blog detailing my development process: [Elixir 练手 + 实战：短链接服务](https://mogeko.me/posts/zh-cn/092/).

The main purpose of this project is to construct a short link service with Elixir + Plug + Ecto(PostgreSQL).

## Installation

First, you need to make sure you have:

- Elixir
- PostgreSQL

Then configure and start your PostgreSQL database.

Next step, clone this GitHub repository, install dependencies, and compile:

```bash
git clone https://github.com/mogeko/link-shortener-api.git
cd link-shortener-api
mix deps.get && mix compile
```

## Usage

Start the service first:

```bash
mix run --no-halt
```

Then open another terminal and use the GET or POST method to send a message to our server:

```bash
curl --request POST \
  --url http://localhost:8080/api/v1 \
  --header 'content-type: application/json' \
  --data '{
    "url": "https://github.com/mogeko/link-shortener-api"
  }'
```

it will return your short link:

```json
{
  "ok":true,
  "short_link":"http://localhost:8080/rX3wvhBV"
}
```

Open your browser and visit `http://localhost:8080/rX3wvhBV`.

It will jump to <https://github.com/mogeko/link-shortener-api>.

## License

The code in this project is released under the [MIT License](https://github.com/mogeko/link-shortener-api/blob/master/LICENSE).
