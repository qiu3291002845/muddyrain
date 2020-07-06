import { TypegooseModule } from 'nestjs-typegoose';
import { Module } from '@nestjs/common';
import { DisplaycardController } from './displaycard.controller';
import { DisplaycardService } from './displaycard.service';
import { displayCard } from '../../schema/displayCard.schema';

@Module({
  imports: [TypegooseModule.forFeature([displayCard])],
  controllers: [DisplaycardController],
  providers: [DisplaycardService]
})
export class DisplaycardModule { }
