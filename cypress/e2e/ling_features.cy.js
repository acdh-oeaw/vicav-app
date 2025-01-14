const BASEX_ROOT = Cypress.env('BASEX_ROOT') || '/app/.heroku/basex'
const BASEX_PWD = Cypress.env('BASEX_admin_pw') || 'admin'
describe('Features', function() {	
    it('should show clickable markers', function() {
		cy.exec(`${BASEX_ROOT}/bin/basexclient -Uadmin -P${BASEX_PWD} -c "OPEN vicav_lingfeatures; REPLACE vicav_lingfeatures_test_toks.xml ${Cypress.config()['fileServerFolder']}/fixtures/vicav_lingfeatures/vicav_lingfeatures_test_toks.xml"`)
	    cy.visit('http://localhost:8984/vicav/#map=[biblMarkers,_features_,]')
		cy.get('#cookie-overlay .cookie-accept-btn').click()
		cy.get('.how-to-panel .chrome-close').click()
		cy.scrollTo(0, 200)
	    cy.get('img.leaflet-marker-icon')
		cy.get('img[alt^="Tunis"]').click({force: true})
		cy.get('a[data-featurelist="vicav_lingfeatures_tunis2"]').click({force: true})
		cy.get('[data-snippetid="vicav_lingfeatures_tunis2"]').contains('h2', 'A List of Linguistic Features of Tunis2 Arabic')
        cy.wait(800)
	    });
})

describe('VICAV Compare features window', function() {
	it ('shows form with the right behavior', function() {
		cy.exec(`${BASEX_ROOT}/bin/basexclient -Uadmin -P${BASEX_PWD} -c "OPEN vicav_lingfeatures; REPLACE vicav_lingfeatures_test2_toks.xml ${Cypress.config()['fileServerFolder']}/fixtures/vicav_lingfeatures/vicav_lingfeatures_test2_toks.xml"`)

		cy.intercept('vicav/data_locations*').as('resources')
		cy.intercept('vicav/explore_samples*').as('results')

	    cy.visit('http://localhost:8984/vicav/')

		cy.get('button.navbar-toggler').then(($navbar_toggler) => {
			if ($navbar_toggler.is(':visible')) {
			  $navbar_toggler.click()
			}
		  })
		cy.get('#cookie-overlay .cookie-accept-btn').click()
		cy.get('.how-to-panel .chrome-close').click()
		cy.scrollTo(0, 200)
		cy.wait(800)
		cy.contains('Feature Lists').click()
		cy.contains('Cross-examine the VICAV Feature Lists').click()
		cy.wait('@resources')
		cy.get('.location-wrapper .tagit input').type('Tun', {force: true})
		cy.get('.tagit-autocomplete .ui-menu-item')
		cy.scrollTo(0, 200)
		cy.wait(800)
		cy.contains('Tunis2').click()
		cy.get('.person-wrapper .tagit input').type('Tes', {force: true})
		cy.get('.tagit-autocomplete .ui-menu-item')
		cy.scrollTo(0, 200)
		cy.wait(800)
		cy.contains('Test1/f/45').click()
        cy.get('.features-wrapper .tagit input').type('who', {force: true})
		cy.get('.tagit-autocomplete .ui-menu-item')
		cy.scrollTo(0, 200)
		cy.wait(800)
	    cy.contains('who?').click()	
        cy.contains('Compare features').click()
		cy.wait('@results', {responseTimeout: 10000})
		cy.scrollTo(0, 200)
		cy.wait(800)
		cy.get('[data-snippetID=compare-features-result]').as('el')
		cy.url().should('contain', '[crossFeaturesResult,type|lingfeatures+xslt|cross_features_02.xslt+location|Tunis2+age|0%2C100+person|Test1+features|semlib%3Awho+translation|+comment|+word|+sex|m%2Cf,open]')	
		cy.get('@el').contains('1 feature sentences found.')
		cy.get('.tdFeaturesRightTarget').as('td')
		cy.get('@td').each(($td, index) => {
			const expected = [
				'škūn hā -ṛ -ṛāžil?– hūwa ṣāḥbi.',
				'škūn iṛ-ṛāžil hǟḏa? – hūwa ṣāḥbi.'
			]
            cy.get($td).contains(expected[index])
		})
		cy.get('@el').contains('Jendouba')
		cy.wait(800)
	}) 
})

