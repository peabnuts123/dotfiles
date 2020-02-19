# Dotfiles

These are my common dotfiles I share between machines. They contain various aliases, functions and environment variables that I frequently use.

Almost everything is wrapped in a check to see whether the alias / function / whatever is relevant to your system (e.g. it won't register an alias for unity unless Unity is installed) so you shouldn't need to modify it much if you want to use it.

These files are made to support bash and zsh. Anything that works in both shells lives in `.bash_profile` and zsh-specific overrides or functionality live in `.zshrc`. This has all been developed and tested only on MacOS. It should work on Linux but might be a bit wonky.

Let me know if you have any suggestions or feedback. You can raise an issue or find me [on Twitter](https://twitter.com/peabnuts123).