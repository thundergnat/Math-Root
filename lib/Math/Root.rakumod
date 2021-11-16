unit module Math::Root:ver<0.0.1>:auth<github:thundergnat>;

# Precision dynamic variable. Number of digits to the right of the decimal
# point. Set if you want a different default than 32.
our $*ROOT-PRECISION is export;


# Integer root of an Integer
sub iroot (
    Int $integer,
    Int $n where * ≥ 2 = 2
    --> Int
    ) is export
{
    my $boundary = $n - 1;
    min (
        exp( $integer.chars div $n max 1, 10 ),
        { ( $boundary * $_ + $integer div exp($boundary, $_) ) div $n } …
        { exp($n, $_) ≤ $integer and exp($n, $_ + 1) > $integer }
    ).tail(2)
}


# Rational root of an Integer
multi root (
    Int $integer,
    Int $n  where * ≥ 2 = 2,
    Int $precision where * > 1 = $*ROOT-PRECISION // 32
    --> FatRat
  ) is export
{
    FatRat.new: iroot( $integer * exp((1 + $precision) * $n, 10), $n ).round(10), exp(1 + $precision, 10)
}


# Rational root of a non-Integer
multi root (
    FatRat(Real) $rat,
    Int $n  where * ≥ 2 = 2,
    Int $precision where * > 1 = $*ROOT-PRECISION // 32
    --> FatRat
    ) is export
{
    FatRat.new: iroot( $rat.numerator * exp((1 + $precision) * $n, 10) div $rat.denominator, $n ).round(10), exp(1 + $precision, 10)
}



=begin pod
=head1 NAME
Math::Root

High accuracy and efficient nth root routines.

=head1 SYNOPSIS

=begin code

    use Math::Root;

    # Integer root of an integer, returns an Integer. (possibly not exact.)
    # Defaults to square root.

    say iroot 2**541;     # integer square root
    # 2682957709556584533771917772160356460380403547217698392041778498789597340712478078

    say iroot 2**541, 3; # integer cube root
    # 1930823390806962193386557101263626480502272594990424863

    say iroot 2**341, 7; # integer seventh root
    # 184212135128821202763601


    # Rational root of Real number, returns a FatRat. Defaults to square root
    # with 32 digits past the decimal point.

    say root 2**541;     # square root
    # 2682957709556584533771917772160356460380403547217698392041778498789597340712478078.25589164260725933347013112601008

    say root 2**541, 3; # cube root
    # 1930823390806962193386557101263626480502272594990424863.73446798343158184700655776636161

    say (2**541).&root(7); # seventh root
    # 184212135128821202763601.0882008101068149236473074788038


=end code

=head1 DESCRIPTION

Calculate Integer or Rational nth root of a number. Provides two routines
depending on which result you desire.

=head3 sub iroot( Int $number, Int $n? --> Int )

=item1 $number
=item2 value; Integer, required.

=item1 $n
=item2 value; positive Integer, optional, defaults to 2.

Efficiently calculates the Integer nth root of an Integer. Returns an Integer.
Fast Integer-only arithmetic. May (very likely) not return an exact root, but
useful in many situations where you don't need the fractional portion. Exponent
n defaults to 2 (square root).

--
=head3 sub root( Real $number, Int $n?, Int $precision? --> FatRat )

=item1 $number
=item2 value; any Real number, required.

=item1 $n
=item2 value; positive Integer > 1, optional, (nth root), default 2 (square root).

=item1 $precision
=item2 value; positive Integer, optional, number of digits to the right of the decimal, default 32.

Calculates the nth root of a Real number. Returns a FatRat, precise to 32
decimal digits by default. May pass in a different precision for more or fewer
fractional digits, or may set the C<$*ROOT-PRECISION> dynamic variable to have a
different default.

=head1 USAGE

Raku nth root calculations return Nums by default. Very useful for small numbers
but of limited value for very large ones. This module provides high accuracy
root functions for both Integer and Rational results.

Contrast the default Raku operations:

=begin code

say sqrt 2**541;       # 2.6829577095565847e+81

say (2**541) ** (1/2); # 2.6829577095565847e+81

=end code

with the Math::Root operations:

=begin code

say iroot 2**541;
# 2682957709556584533771917772160356460380403547217698392041778498789597340712478078

say root 2**541;
# 2682957709556584533771917772160356460380403547217698392041778498789597340712478078.25589164260725933347013112601008

=end code

Note that C<root()> B<always> returns a FatRat. If that will be problematic, coerce
the returned value to some other type. You will lose precision. There is always
a trade-off.

C<root()> returns 32 digits past the decimal point by default. For a different
precision, you may pass in a precision value when you call it, or can adjust the
default precision by setting the C<$*ROOT-PRECISION> dynamic variable to some
positive integer value.

=begin code

say sqrt 2; # Default Raku square root
# 1.4142135623730951

say root 2; # Defaults to n = 2, precision 32
# 1.4142135623730950488016887242097

say root 2, 2, 75; # When passing a precision, also need to specify n (2)
# 1.414213562373095048801688724209698078569671875376948073176679737990732478463

# or

{
    # Set $*ROOT-PRECISION for a different default precision.
    # Localized to prevent scope creep.
    temp $*ROOT-PRECISION = 64;
    say root 2;
    # 1.414213562373095048801688724209698078569671875376948073176679738
}

=end code

C<$n> can be any integer > 1. The examples so far have all used either
an explicit or default of 2, but you can pass in 3 for a cube root, 5 for a
fifth root, 117 for a one hundred seventeenth root, whatever.

=begin code

say root 3, 3; # cube root of 3
# 1.44224957030740838232163831078011

say root 17, 13; # thirteenth root of 17
# 1.24351181796058033975980132060205

=end code

No matter how the precision is set, or what it is set to, the last digit will be
rounded correctly. However, also note that non-significant digits (trailing
zeros) may be dropped.

=begin code

say root 25;           # 5 <-- still a FatRat!
say root 25.0;         # 5 <-- still a FatRat!

# number scale -->                  1         2         3         4         5
# number scale -->         123456789012345678901234567890123456789012345678901
say root 2.123, 2, 51; # 1.457051817884319445661135028125627344205381869400006
say root 2.123, 2, 50; # 1.45705181788431944566113502812562734420538186940001
say root 2.123, 2, 49; # 1.4570518178843194456611350281256273442053818694


=end code

At the time of this writing, there is another module in the ecosystem,
C<BigRoot>, that provides similar high accuracy root functionality. It works
quite nicely but has several drawbacks for my purposes. It is strictly object
oriented; no separate general purpose routines. It doesn't provide specialized
integer root functionality, you would need to calculate a rational root then
truncate. And, in testing, I find it is about 33% slower on average than this
module for Rational roots. Even slower for Integer roots.

=head1 AUTHOR

2021 Steve Schulze aka thundergnat

This package is free software and is provided "as is" without express or implied
warranty. You can redistribute it and/or modify it under the same terms as Perl
itself.

=head1 LICENSE

Licensed under The Artistic 2.0; see LICENSE.


=end pod
