<?php

namespace StringCalculator;

use Exception;

class StringCalculator
{
    private function getSeparator(string $numbers)
    {
        if (stripos($numbers, "//") === 0) {
            $separator = explode("\n", $numbers);

            if (isset($separator[0])) {
                $separator = str_ireplace("//", "", $separator[0]);

                $separatorsArray = null;
                preg_match_all("/(\[.+?\]){1,1}/", $separator, $separatorsArray, PREG_PATTERN_ORDER);

                if (isset($separatorsArray[0])) {
                    $separator = implode("|", $separatorsArray[0]);
                }

                return $separator;
            }
        }

        return null;
    }

    private function getNumbersIfDefinedSeparator($numbers)
    {
        if (stripos($numbers, "//") === 0) {
            $separator = explode("\n", $numbers);

            if (isset($separator[1])) {
                return $separator[1];
            }
        }
    }

    public function add(string $numbers): int
    {
        $definedSeparators = $this->getSeparator($numbers);

        $separators = ",|\n";

        if (!is_null($definedSeparators)) {
            $separators = $definedSeparators;
            $numbers = $this->getNumbersIfDefinedSeparator($numbers);
        }

        $numbersList = preg_split("/({$separators})/", $numbers);

        if (empty($numbers) || empty($numbersList)) {
            return 0;
        }

        //print_r($numbersList);

        foreach ($numbersList as $k => $number) {
            $numbersList[$k] = trim($number);
        }

        $sum = 0;
        $negativeNumbersFound = [];

        foreach ($numbersList as $number) {

            if (is_numeric($number) && $number <= 1000) {
                if ($number < 0) {
                    $negativeNumbersFound[] = $number;
                }
                $sum = $sum + $number;
            }
        }

        if (!empty($negativeNumbersFound)) {
            throw new Exception(implode(", ", $negativeNumbersFound));
        }

        return $sum;
    }
}
