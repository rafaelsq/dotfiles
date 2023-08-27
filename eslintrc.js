// https://github.com/eslint/eslint/blob/main/packages/js/src/configs/eslint-recommended.js
// https://github.com/eslint/eslint/blob/main/packages/js/src/configs/eslint-all.js
module.exports = {
    env: {
        browser: true,
    },
    extends: [
        'eslint:recommended',
    ],
    parserOptions: {
        ecmaVersion: 'latest',
        sourceType: 'module',
    },
    rules: {
        'indent': ['error', 4],
        'linebreak-style': ['error', 'unix'],
        'quotes': ['error', 'single'],
        'semi': ['error', 'never'],
        'max-len': ['error', 120],
        'array-bracket-spacing': ['error', 'never'],
        'object-curly-spacing': ['error', 'never'],
        'comma-dangle': ['error', 'always-multiline'],
        'comma-spacing': 'error',
        'comma-style': 'error',
        'no-multi-spaces': 'error',
        'no-extra-parens': ['error', 'all'],
        'quote-props': ['error', 'consistent-as-needed'],
        'no-trailing-spaces': ['error'],
        'keyword-spacing': ['error'],
        'key-spacing': 'error',
        'arrow-spacing': ['error'],
        'arrow-parens': ['error', 'as-needed'],
        'space-infix-ops': ['error'],
    },
}
