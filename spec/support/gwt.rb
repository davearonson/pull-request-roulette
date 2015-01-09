%i(Given When Then And I).each do |sym|
  define_method(sym) { |args| args }
end
