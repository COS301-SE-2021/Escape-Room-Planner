import { Routes, RouterModule } from '@angular/router';

import { LoginComponent } from './pages/login/login.component';
import { SignupComponent } from './pages/signup/signup.component';
import {RoomCreatorComponent} from "./pages/room-creator/room-creator.component";

const routes: Routes = [
  { path: '', component: RoomCreatorComponent },
  { path: 'signup', component: SignupComponent },
  { path: 'login', component: LoginComponent },
  // otherwise redirect to login
  { path: '**', redirectTo: '' }
];

export const appRoutingModule = RouterModule.forRoot(routes);
