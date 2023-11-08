<?php

namespace App\Models;

// use Illuminate\Contracts\Auth\MustVerifyEmail;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Fortify\TwoFactorAuthenticatable;
use Laravel\Jetstream\HasProfilePhoto;
use Laravel\Sanctum\HasApiTokens;
use Livewire\Features\SupportFileUploads\TemporaryUploadedFile;

class User extends Authenticatable
{
    use HasApiTokens;
    use HasFactory;
    use HasProfilePhoto;
    use Notifiable;
    use TwoFactorAuthenticatable;

    /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'name',
        'dateOfBirth',
        'sex',
        'type',
        'email',
        'password',
    ];

    /**
     * The attributes that should be hidden for serialization.
     *
     * @var array<int, string>
     */
    protected $hidden = [
        'password',
        'remember_token',
        'two_factor_recovery_codes',
        'two_factor_secret',
    ];

    /**
     * The attributes that should be cast.
     *
     * @var array<string, string>
     */
    protected $casts = [
        'email_verified_at' => 'datetime',
    ];

    /**
     * The accessors to append to the model's array form.
     *
     * @var array<int, string>
     */
    protected $appends = [
        'profile_photo_url',
    ];

    public function doctor(){
        return $this->hasOne(Doctor::class, 'doc_id');
    }

    public function user_details(){
        return $this->hasOne(UserDetails::class, 'user_id');
    }

    public function updateProfilePhoto(TemporaryUploadedFile $photo)
    {
        if ($photo) {
            $photoPath = $photo->store('profile-photos', 'public'); // Store the uploaded photo in the 'public' disk under 'profile-photos' directory.
            $this->profile_photo_path = $photoPath; // Update the 'profile_photo_path' attribute in the user model.

            // Save the user model to persist the changes.
            $this->save();

            return $photoPath; // You can return the path to the stored photo if needed.
        }

        return null; // If no photo is provided, return null or handle the case as needed.
    }
}
