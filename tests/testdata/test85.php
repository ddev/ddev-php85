<?php
// Simple PHP test file for testing PHP 8.5 functionality
echo "PHP Version: " . PHP_VERSION . "\n";
echo "PHP 8.5 Test: " . (version_compare(PHP_VERSION, '8.5.0', '>=') ? 'PASS' : 'FAIL') . "\n";

// Test some basic PHP 8.5 features if available
if (version_compare(PHP_VERSION, '8.5.0', '>=')) {
    echo "Testing PHP 8.5 features...\n";
    
    // Test basic functionality
    $test_array = [1, 2, 3, 4, 5];
    echo "Array count: " . count($test_array) . "\n";
    
    // Test phpinfo
    ob_start();
    phpinfo();
    $phpinfo = ob_get_clean();
    echo "phpinfo() works: " . (strlen($phpinfo) > 0 ? 'YES' : 'NO') . "\n";
}