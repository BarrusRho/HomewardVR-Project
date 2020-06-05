using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BrokenHeart : MonoBehaviour
{
    [SerializeField]
    private GameObject _heartPrefab;

    [SerializeField]
    private GameObject _brokenHeartPrefab;

    [SerializeField]
    private Transform _heartSpawnPoint;

    [SerializeField]
    private GameObject _heartExplosionPrefab;

    [SerializeField]
    private Transform _explosionSpawnPoint;

    public AudioClip brokenHeartClip;

    private AudioSource _brokenHeartAudio;

    // Start is called before the first frame update
    void Start()
    {
        _brokenHeartAudio = GameObject.FindGameObjectWithTag("BrokenHeartAudio").GetComponent<AudioSource>();
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    private void OnTriggerEnter(Collider other)
    {
        if(other.tag == "BrokenHeartTrigger")
        {
            Destroy(_heartPrefab, 0f);

            Instantiate(_brokenHeartPrefab, _heartSpawnPoint);

            _brokenHeartAudio.PlayOneShot(brokenHeartClip);

            Instantiate(_heartExplosionPrefab, _explosionSpawnPoint);
            
            Destroy(this.gameObject, 5f);
        }
    }
}
