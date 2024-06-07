describe('Home page', function() {
    const BASEX_ROOT = Cypress.env('BASEX_ROOT') || '/app/.heroku/basex'
    const BASEX_PWD = Cypress.env('BASEX_admin_pw') || 'admin'

	it('should show Tunisia with different config', function() {
    	cy.exec(`${BASEX_ROOT}/bin/basexclient -Uadmin -P${BASEX_PWD} -c "OPEN vicav_projects; REPLACE vicav.xml ${Cypress.config()['fileServerFolder']}/fixtures/vicav_projects/map.xml"`)
		cy.request({
			method: 'PUT',
			url: 'http://localhost:8984/vicav/project',
			headers: {'Accept': 'application/json'}
	    }).as('refreshConfig')
		cy.get('@refreshConfig').should((response) => {
			expect(response.status).to.equal(200)
			expect(response.body.projectConfig).to.exist
		})
		cy.request({
			method: 'GET',
			url: 'http://localhost:8984/vicav/project',
			headers: {'Accept': 'application/json'}
	    }).as('config')
		cy.get('@config').should((response) => {
			expect(response.status).to.equal(200)
			expect(response.body.projectConfig).to.exist
			expect(response.body.projectConfig.cached).to.be.true
			expect(response.body.ETag).to.exist
			expect(response.headers['cache-control']).to.contain('max-age=2')
			expect(response.headers['cache-control']).to.contain('must-revalidate')
		})
		cy.visit('http://localhost:8984/vicav/')
		cy.get('#cookie-overlay').should('be.visible')
		cy.get('.cookie-accept-btn').click()
		cy.get('#cookie-overlay').should('not.be.visible')
	    cy.get('img.leaflet-marker-icon') // Wait until the initial markers appear.
	    cy.get('img[alt^="Khorasan"]').should('not.be.visible');
		cy.wait(1000) // Wait for the cache to expire
    })

	it('should show whole Middle-East by deafult', function() {
    	cy.exec(`${BASEX_ROOT}/bin/basexclient -Uadmin -P${BASEX_PWD} -c "OPEN vicav_projects; REPLACE vicav.xml ${Cypress.config()['fileServerFolder']}/fixtures/vicav_projects/vicav.xml"`)
		cy.request({
			method: 'PUT',
			url: 'http://localhost:8984/vicav/project',
			headers: {'Accept': 'application/json'}
		}).as('refreshConfig')
		cy.get('@refreshConfig').should((response) => {
			expect(response.status).to.equal(200)
			expect(response.body.projectConfig).to.exist
		})
		cy.request({
			method: 'GET',
			url: 'http://localhost:8984/vicav/project',
			headers: {'Accept': 'application/json'}
	    }).as('config')
		cy.get('@config').should((response) => {
			expect(response.status).to.equal(200)
			expect(response.body.projectConfig).to.exist
			expect(response.body.projectConfig.cached).to.be.true
			expect(response.body.ETag).to.exist
		})
		cy.visit('http://localhost:8984/vicav/')
		cy.get('#cookie-overlay').should('be.visible')
		cy.get('.cookie-accept-btn').click()
		cy.get('#cookie-overlay').should('not.be.visible')
    	cy.get('img.leaflet-marker-icon') // Wait until the initial markers appear.
		cy.get('img[alt^="Khorasan"]').should('be.visible');
    })
})