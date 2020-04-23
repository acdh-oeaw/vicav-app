module namespace test = 'http://basex.org/modules/xqunit-tests';
import module namespace vicav = "http://acdh.oeaw.ac.at/vicav" at '../vicav.xqm';

(:~ Initializing function, which is called once before all tests. :)
declare %updating %unit:before-module function test:before-all-tests() {
  db:create('vicav_samples', file:parent(static-base-uri()) || '/../cypress/fixtures/vicav_samples/sampletexts.xml')
};



declare %updating %unit:before-module function test:before-all-test() {
  (:file:write-text(
    file:parent(static-base-uri()) ||'fixtures/explore-samples-gender-age-only.xml', 
    vicav:explore_samples(
      (), 
      (),
      (), 
      (), 
      "0,100", 
      "m,f", 
      (), 
      "cross_samples_01.xslt")):)
};
  
(:~ Initializing function, which is called once after all tests. :)
declare %unit:after-module function test:after-all-tests() {
  ()
};
  
(:~ Initializing function, which is called before each test. :)
declare %unit:before function test:before() {
  ()
};
  
(:~ Initializing function, which is called after each test. :)
declare %unit:after function test:after() {
  ()
};


(:~ Initializing function, which is called after each test. :)
declare %unit:test function test:or_1() {
  unit:assert-equals(vicav:or(("a", ())), "a")
};

(:~ Initializing function, which is called after each test. :)
declare %unit:test function test:or() {
  unit:assert-equals(vicav:or(("a", "b")), "(a or b)")
};

declare %unit:test function test:explore-samples-locations() {
  unit:assert-equals(vicav:explore_samples(
    "Tunis2,Test", 
    "",
    "", 
    "", 
    "0,100", 
    "m,f", 
    "", 
    "cross_samples_01.xslt"), file:read-text(file:parent(static-base-uri()) || 'fixtures/explore-samples-locations.xml'))
};

declare %unit:test function test:explore-samples-word() {
  unit:assert-equals(vicav:explore_samples(
    "", 
    "ṯūm,b*tin*",
    "", 
    "", 
    "", 
    "m,f", 
    "", 
    "cross_samples_01.xslt"), file:read-text(file:parent(static-base-uri()) || 'fixtures/explore-samples-word.xml'))
};

declare %unit:test function test:explore-samples-gender-age-only() {
  unit:assert-equals( vicav:explore_samples(
      (), 
      (),
      (), 
      (), 
      "0,100", 
      "m,f", 
      (), 
      "cross_samples_01.xslt"), file:read-text(file:parent(static-base-uri()) || 'fixtures/explore-samples-gender-age-only.xml'))
};