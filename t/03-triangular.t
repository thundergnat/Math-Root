use Math::Root;

use Test;

plan 21;

is-approx( triangular-root(7140), 119, 'triangular 7140 ok');
is-approx( triangular-root(21408696), 6543, 'triangular 21408696 ok');
is-approx( triangular-root(26728085384), 231205.405565255836957291031961, 'triangular 26728085384 ok');
is-approx( triangular-root(14545501785001), 5393607.158145172316497304724655, 'triangular 14545501785001 ok');

is-approx( tetrahedral-root(7140), 34, 'tetrahedral 7140 ok');
is-approx( tetrahedral-root(21408696), 503.56182697463651404819613, 'tetrahedral 21408696 ok');
is-approx( tetrahedral-root(26728085384), 5432, 'tetrahedral 26728085384 ok');
is-approx( tetrahedral-root(14545501785001), 44355.777384073256052620916903, 'tetrahedral 14545501785001 ok');

is-approx( triangular-root(7140,3), 34, 'indirect tetrahedral 7140 ok');
is-approx( triangular-root(21408696,3), 503.56182697463651404819613, 'indirect tetrahedral 21408696 ok');
is-approx( triangular-root(26728085384,3), 5432, 'indirect tetrahedral 26728085384 ok');
is-approx( triangular-root(14545501785001,3), 44355.777384073256052620916903, 'indirect tetrahedral 14545501785001 ok');

is-approx( pentatopic-root(7140), 18.876646615928006607901783, 'pentatopic 7140 ok');
is-approx( pentatopic-root(21408696), 149.060947375265867484387575, 'pentatopic 21408696 ok');
is-approx( pentatopic-root(26728085384), 893.442456751684869888466212, 'pentatopic 26728085384 ok');
is-approx( pentatopic-root(14545501785001), 4321, 'pentatopic 14545501785001 ok');

is-approx( triangular-root(7140,4), 18.876646615928006607901783, 'indirect pentatopic 7140 ok');
is-approx( triangular-root(21408696,4), 149.060947375265867484387575, 'indirect pentatopic 21408696 ok');
is-approx( triangular-root(26728085384,4), 893.442456751684869888466212, 'indirect pentatopic 26728085384 ok');
is-approx( triangular-root(14545501785001,4), 4321, 'indirect pentatopic 14545501785001 ok');

fails-like { triangular-root(7140,6) }, X::AdHoc, :message(/'Sorry, unable to calculate 6-simplex root'/), 'fails ok on invalid parameter';

done-testing;
