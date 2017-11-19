package DeepClone;
# vim: noet:

use 5.016;
use warnings;

=encoding UTF8

=head1 SYNOPSIS

Клонирование сложных структур данных

=head1 clone($orig)

Функция принимает на вход ссылку на какую либо структуру данных и отдаюет, в качестве результата, ее точную независимую копию.
Это значит, что ни один элемент результирующей структуры, не может ссылаться на элементы исходной, но при этом она должна в точности повторять ее схему.

Входные данные:
* undef
* строка
* число
* ссылка на массив
* ссылка на хеш
Элементами ссылок на массив и хеш, могут быть любые из указанных выше конструкций.
Любые отличные от указанных типы данных -- недопустимы. В этом случае результатом клонирования должен быть undef.

Выходные данные:
* undef
* строка
* число
* ссылка на массив
* ссылка на хеш
Элементами ссылок на массив или хеш, не могут быть ссылки на массивы и хеши исходной структуры данных.

=cut

sub clone($);
sub clone($) {
    if (my $ref = ref $_[0]) {
        if ($ref eq 'ARRAY') {
            return [map {clone($_)} @{$_[0]}];
        } elsif ($ref eq 'HASH') {
            my @hash_arr;
            while (my ($k,$v) = each %{$_[0]}) {
                push @hash_arr, clone($k);
                push @hash_arr, clone($v);
            }
            return {@hash_arr}
        } else {
            return;
        }
    } else {
        return $_[0];
    }
}

1;
