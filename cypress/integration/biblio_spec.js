describe('Bibliography', function() {
    it('should show clickable markers', function() {
	    cy.visit('http://localhost:8984/vicav/#map=[biblMarkers,.*,geo]')
	    cy.get('img.leaflet-marker-icon') // Wait until the initial markers appear.

	    cy.get('img[alt^="Tunis"]').click({force: true});
	    cy.contains('geo:Tunis & .*')
	    cy.get('.dvBibBook')
    })
})

describe('Regional bibliography', function() {
    it('should show clickable regions', function() {
	    cy.visit('http://localhost:8984/vicav/#map=[biblMarkers,.*,reg]')
	    cy.get('path.leaflet-interactive') // Wait until the initial markers appear.

	    cy.get('path[data-testid="reg_Tunisia"]')
	    	.scrollIntoView()
	    	.trigger('mouseover', {force: true})
	    	.then(function (el) {
		    	cy.contains('Tunisia')
		    	cy.get(el).click({force: true})
		    cy.contains('reg:Tunisia & .*')
		    cy.get('.dvBibBook')
		})
    })
})

describe('Dictionaries bibliography', function() {
    it('should show clickable regions and markers', function() {
	    cy.visit('http://localhost:8984/vicav/#map=[biblMarkers,vt:dictionary,geo_reg]')
	    cy.get('path.leaflet-interactive') // Wait until the initial markers appear.

	    cy.get('path[data-testid="reg_Tunisia"]')
	    	.scrollIntoView()
	    	.trigger('mouseover', {force: true})
	    	.then(function (el) {
		    	cy.contains('Tunisia')
		    	cy.get(el).click({force: true})
		    cy.contains('reg:Tunisia & vt:dictionary')
		    cy.get('.dvBibBook')
		})

	    cy.get('img[data-testid="geo_Douz"]').click({force: true}).then(el => {
		    cy.contains('geo:Douz & vt:dictionary')
	    })
    })
})


describe('Textbooks bibliography', function() {
    it('should show clickable regions and markers', function() {
	    cy.visit('http://localhost:8984/vicav/#map=[biblMarkers,vt:textbook,geo_reg]')
	    cy.get('path.leaflet-interactive') // Wait until the initial markers appear.

	    cy.get('path[data-testid="reg_Tunisia"]')
	    	.scrollIntoView()
	    	.trigger('mouseover', {force: true})
	    	.then(function (el) {
		    	cy.contains('Tunisia')
		    	cy.get(el).click({force: true})
		    cy.contains('reg:Tunisia & vt:textbook')
		    cy.get('.dvBibBook')
		})

	    cy.get('img[alt^="Ouaday"]').click({force: true}).then(el => {
		    cy.contains('geo:Ouaday &vt:textbook')
	    })
    })
})