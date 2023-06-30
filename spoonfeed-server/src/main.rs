use axum::{Router, routing::get};

mod config;
mod routes;

#[tokio::main]
async fn main() {
    let config = config::init();

    let app = Router::new()
        .route("/", get(|| async { "Hello, world!" }))
        .route("/static/*path", get(routes::static_path));

    let address = format!("{}:{}", config.address, config.port);

    axum::Server::bind(&address.parse().unwrap())
        .serve(app.into_make_service())
        .await
        .unwrap();
}