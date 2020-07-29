import { Girl } from './../../schema/girl.schema copy';
import { SecondCategory } from './../../schema/secondCategory.schema';
import { FirstCategory } from './../../schema/firstCategory.schema';
import { TypegooseModule } from 'nestjs-typegoose';
import { Module } from '@nestjs/common';
import { GirlService } from './girl.service';
import { GirlController } from './girl.controller';
import { GirlCategory } from '../../schema/girlCategory.schema';
import { GirlColthing } from '../../schema/girlcolthing.schema';

@Module({
  imports:[TypegooseModule.forFeature([GirlCategory,GirlColthing,FirstCategory,SecondCategory,Girl])],
  providers: [GirlService],
  controllers: [GirlController],
})
export class GirlModule {}
