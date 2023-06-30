use std::fs;

use serde::Deserialize;

const CONFIG_DIR: &str = "./config/";

#[derive(Deserialize)]
pub struct Config {
    pub address: String,
    pub port: i32,
}

//TODO: Handle errors from TOML parse failure
pub fn init() -> Config {
    let contents = fs::read_to_string(CONFIG_DIR.to_owned() + "config.toml").unwrap();
    toml::from_str(&contents).unwrap()
}