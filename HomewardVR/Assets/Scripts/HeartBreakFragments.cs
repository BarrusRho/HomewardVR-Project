using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HeartBreakFragments : MonoBehaviour
{
    [SerializeField]
    private MeshRenderer _heartFragment001;

    [SerializeField]
    private MeshRenderer _heartFragment002;

    [SerializeField]
    private MeshRenderer _heartFragment003;

    [SerializeField]
    private Transform _fragmentSpawnPoint001;

    [SerializeField]
    private Transform _fragmentSpawnPoint002;

    [SerializeField]
    private Transform _fragmentSpawnPoint003;

    [SerializeField]
    private GameObject _heartFragmentExplosionPrefab;

    public AudioClip shatterHeartClip;

    private AudioSource _shatterHeartAudio;

    // Start is called before the first frame update
    void Start()
    {
        _shatterHeartAudio = GameObject.FindGameObjectWithTag("AudioManager").GetComponent<AudioSource>();

        Invoke("SpawnHeartFragments", 2.4f);
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    void SpawnHeartFragments()
    {
        _heartFragment001.enabled = false;

        _heartFragment002.enabled = false;

        _heartFragment003.enabled = false;

        _shatterHeartAudio.PlayOneShot(shatterHeartClip);

        Instantiate(_heartFragmentExplosionPrefab, _fragmentSpawnPoint001);

        Instantiate(_heartFragmentExplosionPrefab, _fragmentSpawnPoint002);

        Instantiate(_heartFragmentExplosionPrefab, _fragmentSpawnPoint003);
    }
}
