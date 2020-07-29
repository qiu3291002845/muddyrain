import { ModelOptions, prop } from "@typegoose/typegoose";
@ModelOptions(
  {
    schemaOptions: {
      timestamps: true,
    }
  }
)
export class SecondCategory {
  @prop()
  secondCategoryName: String;
}