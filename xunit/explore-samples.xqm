module namespace test = 'http://basex.org/modules/xqunit-tests';
import module namespace vicav = "http://acdh.oeaw.ac.at/vicav" at '../vicav.xqm';
declare namespace tei = 'http://www.tei-c.org/ns/1.0';

(:~ Initializing function, which is called once before all tests. :)
declare %updating %unit:before-module function test:before-all-tests() {
};

declare %updating %unit:before-module function test:before-all-test() {
  (: Gererate new fixtures with this
  file:write-text(
    file:parent(static-base-uri()) ||'../fixtures/explore-samples-location-person-data.xml', 
    serialize(vicav:explore-data(
      "Tunis2", 
      (),
      (), 
      "Test1", 
      "0,100", 
      (), 
      (), 
      "cross_samples_01.xslt"))
  ):)
};
  
(:~ Initializing function, which is called once after all tests. :)
declare %updating %unit:after-module function test:after-all-tests() {
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
 unit:assert-equals(vicav:explore-data(
    "vicav_samples",
    "Tunis2,Test", 
    "",
    "", 
    "0,100", 
    "")//tei:TEI/@xml:id/data(), ('tunis2_sample_01', 'test_sample_01', 'test_sample_02')
 )
};

declare %unit:test function test:explore-samples-word() {
  unit:assert-equals(vicav:explore-data(
    "vicav_samples",
    "", 
    "ṯūm,b*tin*",
    "", 
    "", 
    "")//tei:TEI/@xml:id/data(), ('tunis2_sample_01', 'test_sample_01')
  )
};

declare %unit:test function test:explore-samples-gender-age-only() {
  unit:assert-equals(vicav:explore-data(
    "vicav_samples",
      (), 
      (),
      (), 
      "0,100", 
      "m,f")//tei:TEI/@xml:id/data(), ('test_sample_01', 'test_sample_02')
  )
};


declare %unit:test function test:explore-samples-locations-persons-data() {
  unit:assert-equals(vicav:explore-data(
    "vicav_samples",
      "Tunis2", 
      (),
      "Test2", 
      "0,100", 
      ())//tei:TEI/@xml:id/data(), ('tunis2_sample_01', 'test_sample_02')
  )
};


declare %unit:test function test:explore-samples-person-only-data() {
  unit:assert-equals(vicav:explore-data(
    "vicav_samples",
      (), 
      (),
      "Test1", 
      "0,100", 
      "m,f")//tei:TEI/@xml:id/data(), ('test_sample_01')
  )
};

declare %unit:test function test:explore-lingfeatures-locations-data() {
  unit:assert-equals(vicav:explore-data(
    "vicav_lingfeatures",
      "Test", 
      (),
      (),
      (), 
      ())//tei:TEI/@xml:id/data(), ('ling_features_test')
  )
};

declare %unit:test function test:explore-lingfeatures-data() {
  unit:assert-equals(vicav:explore-data(
    "vicav_lingfeatures",
      (), 
      (),
      (),
      "0,100", 
      ())//tei:TEI/@xml:id/data(), ('ling_features_test')
  )
};