<?php

namespace Tests\StringCalculator;

use Exception;
use PHPUnit\Framework\TestCase;
use StringCalculator\StringCalculator;

class StringCalculatorTest extends TestCase
{
    /**
     * @test
     */
    public function emptyStringReturnZero()
    {
        $stringCalculator = new StringCalculator();

        $this->assertEquals(0, $stringCalculator->add(""));
    }

    /**
     * @test
     */
    public function oneValueStringReturnValue()
    {
        $stringCalculator = new StringCalculator();

        $this->assertEquals(1, $stringCalculator->add("1"));
        $this->assertEquals(7, $stringCalculator->add("7"));
        $this->assertEquals(99, $stringCalculator->add("99"));
    }

    /**
     * @test
     */
    public function twoValueStringReturnSum()
    {
        $stringCalculator = new StringCalculator();

        $this->assertEquals(7, $stringCalculator->add("1, 6"));
        $this->assertEquals(20, $stringCalculator->add("7, 13"));
        $this->assertEquals(109, $stringCalculator->add("99, 10"));
    }

    /**
     * @test
     */
    public function threeOrMoreValueStringReturnSum()
    {
        $stringCalculator = new StringCalculator();

        $this->assertEquals(16, $stringCalculator->add("1, 6, 9"));
        $this->assertEquals(30, $stringCalculator->add("7, 13, 10"));
        $this->assertEquals(130, $stringCalculator->add("99, 10, 10, 11"));
    }

    /**
     * @test
     */
    public function threeOrMoreValueDifferentSeparatorsStringReturnSum()
    {
        $stringCalculator = new StringCalculator();

        $this->assertEquals(6, $stringCalculator->add("1\n2,3"));
        $this->assertEquals(6, $stringCalculator->add("1\n2\n3"));
        $this->assertEquals(10, $stringCalculator->add("1\n2,3\n4"));
    }

    /**
     * @test
     */
    public function definedSeparatorStringReturnSum()
    {
        $stringCalculator = new StringCalculator();

        $this->assertEquals(3, $stringCalculator->add("//;\n1;2"));
    }

    /**
     * @test
     */
    public function threeOrMoreNegativeValueStringReturnException()
    {
        $stringCalculator = new StringCalculator();

        $this->expectException(Exception::class);
        $this->expectExceptionMessage("-1, -9");
        $this->assertEquals(16, $stringCalculator->add("-1, 6, -9"));
        $this->expectException(Exception::class);
        $this->expectExceptionMessage("-13");
        $this->assertEquals(30, $stringCalculator->add("7, -13, 10"));
    }

    /**
     * @test
     */
    public function threeOrMoreValueStringReturnSumBigValuesIgnored()
    {
        $stringCalculator = new StringCalculator();

        $this->assertEquals(1007, $stringCalculator->add("1, 6, 1000"));
        $this->assertEquals(20, $stringCalculator->add("7, 13, 1001"));
        $this->assertEquals(120, $stringCalculator->add("99, 10, 1001, 11"));
    }

    /**
     * @test
     */
    public function definedAnyLengthSeparatorStringReturnSum()
    {
        $stringCalculator = new StringCalculator();

        $this->assertEquals(6, $stringCalculator->add("//[***]\n1***2***3"));
    }

    /**
     * @test
     */
    public function definedAnyLengthMultileSeparatorStringReturnSum()
    {
        $stringCalculator = new StringCalculator();

        $this->assertEquals(6, $stringCalculator->add("//[***][$$$$$]\n1***2$$$$$3"));
        $this->assertEquals(10, $stringCalculator->add("//[***][%%][$$$$$]\n1***2$$$$$3%%4"));
    }
}
