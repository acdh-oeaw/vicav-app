describe('Profiles', function() {
    it('should show clickable markers', function() {
	    cy.visit('http://localhost:8984/vicav/#map=[biblMarkers,_profiles_]')
	    cy.get('img.leaflet-marker-icon') // Wait until the initial markers appear.

	    cy.get('img[alt^="Tunis"]').click({force: true})

	    cy.get('img[src="images/tunis-zeituna-1988.jpg"]').should('be.visible')
	    cy.contains("‏تونس")    
    });
})


