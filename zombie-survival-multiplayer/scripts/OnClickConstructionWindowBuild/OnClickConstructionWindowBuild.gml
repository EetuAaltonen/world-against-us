function OnClickConstructionWindowBuild()
{
	if (!is_undefined(metadata))
	{
		if (!is_undefined(metadata.blueprint_tag))
		{
			var blueprintData = global.BlueprintData[? metadata.blueprint_tag];
			if (!is_undefined(blueprintData))
			{
				var blueprintDataCount = array_length(blueprintData);
				for (var i = 0; i < blueprintDataCount; i++)
				{
					var blueprint = blueprintData[@ i];
					if (!is_undefined(blueprint))
					{
						if (!is_undefined(metadata.material_slots))
						{
							// CHECK IF RECIPE IS FULFILLED
							var requiredMaterialsClone = CloneArrayMaterialsWithClonedValues(blueprint.materials);
							if (array_length(requiredMaterialsClone) > 0)
							{
								var materialSlotCount = array_length(metadata.material_slots);
								for (var j = 0; j < materialSlotCount; j++)
								{
									var materialSlot = metadata.material_slots[@ j];
									if (!is_undefined(materialSlot))
									{
										var materialItem = materialSlot.GetItemByIndex(0);
										if (!is_undefined(materialItem))
										{
											var materialRequirementCount = array_length(requiredMaterialsClone);
											for (var k = 0; k < materialRequirementCount; k++)
											{
												var material = requiredMaterialsClone[@ k];
												if (materialItem.name == material.name)
												{
													material.quantity -= min(material.quantity, materialItem.quantity);
													if (material.quantity <= 0)
													{
														array_delete(requiredMaterialsClone, k, 1);
													}
													break;
												}
											}
										}
									}
								}
						
								// CHECK IF ALL MATERIAL REQUIRMENTS ARE MEET
								if (array_length(requiredMaterialsClone) <= 0)
								{
									// DELETE USED MATERIALS FROM ITEM SLOTS
									var originalRequiredMaterialsClone = CloneArrayMaterialsWithClonedValues(blueprint.materials);
									var materialSlotCount = array_length(metadata.material_slots);
									for (var i = 0; i < materialSlotCount; i++)
									{
										var materialSlot = metadata.material_slots[@ i];
										if (!is_undefined(materialSlot))
										{
											var materialItem = materialSlot.GetItemByIndex(0);
											if (!is_undefined(materialItem))
											{
												var materialRequirementCount = array_length(originalRequiredMaterialsClone);
												for (var j = 0; j < materialRequirementCount; j++)
												{
													var requiredMaterial = originalRequiredMaterialsClone[@ j];
													if (materialItem.name == requiredMaterial.name)
													{
														var matchedQuantity = min(requiredMaterial.quantity, materialItem.quantity);
														materialItem.quantity -= matchedQuantity;
														requiredMaterial.quantity -= matchedQuantity;
														// REMOVE REQUIRED MATERIAL FROM THE CHECK LIST
														if (requiredMaterial.quantity <= 0)
														{
															array_delete(originalRequiredMaterialsClone, j, 1);
														}
														break;
													}
												}
											
												// RESTORE EXTRA MATERIALS TO BACKPACK
												if (materialItem.quantity > 0)
												{
													// TODO: Material restore fails if inventory is full, item is still deleted
													global.PlayerBackpack.AddItem(materialItem);
												}
												materialItem.sourceInventory.RemoveItemByGridIndex(materialItem.grid_index);
											}
										}
									}
									
									// SPAWN THE BUILDING
									var constructionSiteInstance = metadata.construction_site;
									if (!is_undefined(constructionSiteInstance))
									{
										var outputBuilding = asset_get_index(blueprint.output_building_object);
										if (outputBuilding != -1)
										{
											with (constructionSiteInstance)
											{
												instance_create_depth(x, y, depth, outputBuilding);
												instance_destroy();
											}
										}
									}
									global.GUIStateHandlerRef.CloseCurrentGUIState();
									break;
								} else {
									show_message(string(requiredMaterialsClone));
								}
							}
						}
					}
				}
			}
		}
	}
}