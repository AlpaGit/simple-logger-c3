module test;

import logger;

fn void main() 
{   
	logger::info("Something interesting happened !");
	logger::warn("A simple warn");
	logger::error("Gone wrong");
	logger::debug("Lets ignore that");
}