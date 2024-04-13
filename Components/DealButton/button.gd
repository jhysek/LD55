extends Button

func set_deal(deal):
	set_price(deal.price)
	set_product(deal.ability)

func set_price(price):
	if price.has('lives'):
		$Price/Number.text = str(price.lives) + " x "
		$Price/Commodity.show()
	else:
		$Price/Number.text = price.name
		$Price/Commodity.hide()

func set_product(product):
	if product.has('lives'):
		text = str(product.lives) + " x "
		$Commodity.show()
	else:
		text = product.name
		$Commodity.hide()