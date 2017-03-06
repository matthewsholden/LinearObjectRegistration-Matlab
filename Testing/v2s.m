% Convert a vector v into its corresponding cross-product matrix s

function s = v2s(v)

s = [ 0, -v(3), v(2); v(3), 0, -v(1); -v(2), v(1), 0 ];