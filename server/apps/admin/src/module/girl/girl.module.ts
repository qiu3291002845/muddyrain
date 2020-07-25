import { TypegooseModule } from 'nestjs-typegoose';
import { Module } from '@nestjs/common';
import { GirlService } from './girl.service';
import { GirlController } from './girl.controller';
import { GirlCategory } from '../../schema/girlCategory.schema';
import { GirlColthing } from '../../schema/girlcolthing.schema';

@Module({
  imports:[TypegooseModule.forFeature([GirlCategory,GirlColthing])],
  providers: [GirlService],
  controllers: [GirlController],
})
export class GirlModule {}
