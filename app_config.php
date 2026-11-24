<?php
declare(strict_types=1);

function gjwConfigPath(): string
{
    $explicit = getenv('GJW_CONFIG_FILE');
    if ($explicit !== false && $explicit !== '') {
        return $explicit;
    }
    $dir = __DIR__;
    while (basename($dir) !== 'public_html' && dirname($dir) !== $dir) {
        $dir = dirname($dir);
    }
    if (basename($dir) === 'public_html') {
        $storageName = __DIR__ === $dir ? 'assessment_private' : 'assessment_stage08_private';
        $private = dirname($dir).'/'.$storageName.'/config.php';
        if (is_file($private) || __DIR__ !== $dir) {
            return $private;
        }
    }
    return __DIR__.'/config.php';
}
