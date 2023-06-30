use axum::{Router, routing::get};
use log::info;

mod config;
mod routes;

#[tokio::main]
async fn main() {
    env_logger::init();
    info!("Initializing Spoonfeed.");

    let config = config::init();
    info!("Loaded configs.");
    
    let app = Router::new()
    .route("/", get(|| async { "Hello, world!" }))
    .route("/static/*path", get(routes::static_path));

    let address = format!("{}:{}", config.address, config.port);
    info!("Starting Spoonfeed Server on {}.", address);


    axum::Server::bind(&address.parse().unwrap())
        .serve(app.into_make_service())
        .await
        .unwrap();
}