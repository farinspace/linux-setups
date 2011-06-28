<?php

require_once 'PHPUnit/Extensions/SeleniumTestCase.php';

class Example extends PHPUnit_Extensions_SeleniumTestCase
{
	protected function setUp()
	{
		$this->setBrowser("*firefox");

		$this->setBrowserUrl("http://www.google.com/");
	}

	public function testMyTestCase()
	{
		$this->open("http://www.farinspace.com/");

		$this->assertEquals("About Dimas", $this->getText("css=#custom_box h2 a"));
	}
}
